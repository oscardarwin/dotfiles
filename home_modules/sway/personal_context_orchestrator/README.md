I'd like to respec this slightly. We call this software pcp (Personal Context Processor) The config only needs a few things


1. "create or switch to context" set of key modifiers (alt, window key, alt gr) 
First it extracts the current set of contexts by getting all workspaces, and parsing the result into context and workspace_name pairings.

Then this key updates the Arc<Mut< context tag to the result of a wofi window which lists all the current contexts and allows the user to switch or type in what they wish. It then switches to, or creates the sway workspace 1:context_name.

2. "context aware create or switch to searched workspace" set of key modifiers (alt, window key, alt gr):
When this key modifier is run with a keyboard character, run the following:
a. get and parse all current workspaces into context and workspace name.  
b. check if any workspace_names in the current context (read from Arc<Mut<) begin with the character typed.
c. if so, just switch to the first workspace in the list of found workspaces.
d. if not, look in a list of explicit character + program pairings (given as a set of nix options which is an attribute set from character to package mapping). If one matches, create that workspace, start the program in that workspace and then switch to that workspace.
e. if letter does not appear in the explicit character program pairings, open a wofi window to search for programs that begin with that letter, take the users result and create a new workspace: "program:context_name", in this workspace run the program then switch to that workspace.

3. "context aware move container to workspace" set of key modifiers (alt, ...)
When this key modifier is run with a keyboard character, run the following:
a. get and parse all current workspaces into context and workspace_name
b. check if any workspace_names in the current context (read from Arc<Mut<) begin with the character typed.
c. if so, move the current container to the first workspace in the list of found workspaces.
d. if not, move the current container to the workspace "character:context_name".

The nix half of this software should generate sway nix keybindings from the given key modifiers. Each sway keybinding should basically call one of:

pcp context letter
pcp workspace letter
pcp program letter
pcp move letter

Then the rust program should perform the associated function.

Let's start with the rust program. Is it possible write a program to call a picked of lock controller memory that can be started separately as a daemon and persisted outside the life of the program? Please don't write any code to solve the above yet. Let's just get some questions out the way first.

## Nix Side

Next up we will generate our sway keybindings.

We need the following options as input:

setWorkspaceKeybindings - contains a map from letter/numbers to a attr set of workspace names and executable paths.

contextSwitchKeyModifiers
for every letter / number writes a sway keybinding with the specified modifiers + the letter / number.
exec systemd-run --user --scope --quiet pcp-client -- create-or-switch-to-context <letter/number>

containerMoveKeyModifiers - set of keyboard modifiers (alt, alt gr, windows key)
for every letter / number writes a sway keybinding with the specified modifiers + the letter / number.
exec systemd-run --user --scope --quiet pcp-client -- move-to-workspace <letter/number>

workspaceSwitchKeyModifiers
for every letter / number writes a sway keybinding with the specified modifiers + the letter / number.
If the letter matches to an entry in setWorkspaceKeybindings, the run the following command:

exec systemd-run --user --scope --quiet pcp-client -- create-or-switch-to-set-workspace <workspace name> <executable path>

or if nothing matches in setWorkspaceKeybindings:

exec systemd-run --user --scope --quiet pcp-client -- create-or-switch-to-workspace <letter>

please create the module.nix that accomplishes this

