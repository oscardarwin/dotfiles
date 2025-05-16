#!/usr/bin/env bash
set +e

# JS field injection code from https://github.com/qutebrowser/qutebrowser/blob/main/misc/userscripts/password_fill
javascript_escape() {
    sed "s,[\\\\'\"\/],\\\\&,g" <<< "$1"
}

js() {
cat <<EOF
    function isVisible(elem) {
        var style = elem.ownerDocument.defaultView.getComputedStyle(elem, null);
        if (style.getPropertyValue("visibility") !== "visible" ||
            style.getPropertyValue("display") === "none" ||
            style.getPropertyValue("opacity") === "0") {
            return false;
        }
        return elem.offsetWidth > 0 && elem.offsetHeight > 0;
    };
    function hasPasswordField(form) {
        var inputs = form.getElementsByTagName("input");
        for (var j = 0; j < inputs.length; j++) {
            var input = inputs[j];
            if (input.type == "password") {
                return true;
            }
        }
        return false;
    };
    function loadData2Form (form) {
        var inputs = form.getElementsByTagName("input");
        for (var j = 0; j < inputs.length; j++) {
            var input = inputs[j];
            if (isVisible(input) && (input.type == "text" || input.type == "email")) {
                input.focus();
                input.value = "$(javascript_escape "${USERNAME}")";
                input.dispatchEvent(new Event('change'));
                input.blur();
            }
            if (input.type == "password") {
                input.focus();
                input.value = "$(javascript_escape "${PASSWORD}")";
                input.dispatchEvent(new Event('change'));
                input.blur();
            }
        }
    };
    var forms = document.getElementsByTagName("form");
    if("$(javascript_escape "${QUTE_URL}")" == window.location.href) {
        for (i = 0; i < forms.length; i++) {
            if (hasPasswordField(forms[i])) {
                loadData2Form(forms[i]);
            }
        }
    } else {
        alert("Secrets will not be inserted.\nUrl of this page and the one where the user script was started differ.");
    }
EOF
}

env > /tmp/qute-env.txt
{ which op; which jq; } >> /tmp/qute-env.txt
echo "TOKEN: $TOKEN" >> /tmp/qute-env.txt

echo "message-info 'Looking for password for $QUTE_URL...'" >> "$QUTE_FIFO"

if ! op account get > /dev/null 2>&1; then
    echo "message-info 'Signing into 1Password.'" >> "$QUTE_FIFO"
    eval "$(op signin)" || {
        echo "message-error 'Failed to sign in to 1Password.'" >> "$QUTE_FIFO"
        exit 1
    }
fi

DOMAIN=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/^www\.//')

MATCH_URL=$(echo "$QUTE_URL" | sed -E 's,(\?.*)?$,,')
op item list --format json

OP_COUNT=$(op item list --format json)

echo "message-info 'matches $OP_COUNT.'" >> "$QUTE_FIFO"

# Try fuzzy matching by URL first
MATCHING_ITEMS=$(op item list --format json | jq -r --arg url "$DOMAIN" '
  [.[] | select(.urls[]?.href | test($url))] | .[0]')

if [ -z "$MATCHING_ITEMS" ] || [ "$MATCHING_ITEMS" = "null" ]; then
    echo "message-info 'No matching item for domain $DOMAIN. Prompting for title...'" >> "$QUTE_FIFO"
    
    # Get list of item titles and prompt user to select one
    TITLE=$(op item list --format json | jq -r '.[].title' | rofi -dmenu -i -p "1Password Title")
    if [ -z "$TITLE" ]; then
        echo "message-error 'No title selected.'" >> "$QUTE_FIFO"
        exit 1
    fi

    # Let op do the fuzzy title matching
    ITEM=$(op item get "$TITLE" --format json 2>/dev/null)
    if [ -z "$ITEM" ]; then
        echo "message-error 'No item found with title matching $TITLE'" >> "$QUTE_FIFO"
        exit 1
    fi
else
    UUID=$(echo "$MATCHING_ITEMS" | jq -r '.id')
    ITEM=$(op item get "$UUID" --format json)
fi

USERNAME=$(echo "$ITEM" | jq -r '.fields[] | select(.id == "username" or .label == "username") | .value')
PASSWORD=$(echo "$ITEM" | jq -r '.fields[] | select(.id == "password" or .label == "password") | .value')

if [ -n "$USERNAME" ] && [ -n "$PASSWORD" ]; then
    printjs() {
        js | sed 's,//.*$,,' | tr '\n' ' '
    }
    echo "jseval -q $(printjs)" >> "$QUTE_FIFO"

    TOTP=$(op item get "$UUID" --otp) || TOTP=""
    if [ -n "$TOTP" ]; then
        echo "$TOTP" | xclip -in -selection clipboard
        echo "message-info 'Pasted one-time password for $TITLE to clipboard'" >> "$QUTE_FIFO"
    fi
else
    echo "message-error 'Username or password missing in 1Password item.'" >> "$QUTE_FIFO"
fi
