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
            loadData2Form(forms[i]);
        }
    } else {
        alert("Secrets will not be inserted.\nUrl of this page and the one where the user script was started differ.");
    }
EOF
}

OP_SESSION=$(systemctl --user show-environment | grep '^OP_SESSION=' | cut -d= -f2-)

echo "message-info 'Looking for password for $QUTE_URL...'" >> "$QUTE_FIFO"

DOMAIN=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/^www\.//')

MATCHING_ITEMS=$(op item list --format json --session "$OP_SESSION" | jq -r --arg url "$DOMAIN" '
  [.[] | select(.urls[]?.href | test($url))] | .[0]')

if [ -z "$MATCHING_ITEMS" ] || [ "$MATCHING_ITEMS" = "null" ]; then
    echo "message-info 'No matching item for domain $DOMAIN. Prompting for title...'" >> "$QUTE_FIFO"
    
    # Get list of item titles and prompt user to select one
    TITLE=$(op item list --format json --session "$OP_SESSION" | jq -r '.[].title' | wofi --dmenu -i -p "1Password Title")
    if [ -z "$TITLE" ]; then
        echo "message-error 'No title selected.'" >> "$QUTE_FIFO"
        exit 1
    fi

    # Let op do the fuzzy title matching
    ITEM=$(op item get "$TITLE" --format json --session "$OP_SESSION" 2>/dev/null)
    if [ -z "$ITEM" ]; then
        echo "message-error 'No item found with title matching $TITLE'" >> "$QUTE_FIFO"
        exit 1
    fi
else
    UUID=$(echo "$MATCHING_ITEMS" | jq -r '.id')
    ITEM=$(op item get "$UUID" --format json --session "$OP_SESSION")
fi


USERNAME=$(echo "$ITEM" | jq -r '.fields[] | select(.id == "username" or .label == "username") | .value')
PASSWORD=$(echo "$ITEM" | jq -r '.fields[] | select(.id == "password" or .label == "password") | .value')

if [ -n "$USERNAME" ] || [ -n "$PASSWORD" ]; then
    printjs() {
        js | sed 's,//.*$,,' | tr '\n' ' '
    }
    echo "jseval -q $(printjs)" >> "$QUTE_FIFO"

    echo "message-info 'Attempting to paste one-time password for $TITLE with $UUID to clipboard'" >> "$QUTE_FIFO"
    TOTP=$(op item get "$UUID" --otp --session "$OP_SESSION") || TOTP=""
    if [ -n "$TOTP" ]; then
        echo "$TOTP" | wl-copy
        echo "message-info 'pasted TOTP to clipboard'" >> "$QUTE_FIFO"
    fi
else
    echo "message-error 'Username or password missing in 1Password item.'" >> "$QUTE_FIFO"
fi
