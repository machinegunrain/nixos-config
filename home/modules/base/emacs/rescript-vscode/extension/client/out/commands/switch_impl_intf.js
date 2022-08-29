"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.switchImplIntf = void 0;
const fs = require("fs");
const vscode_1 = require("vscode");
const create_interface_1 = require("./create_interface");
const switchImplIntf = async (client) => {
    if (!client) {
        return vscode_1.window.showInformationMessage("Language server not running");
    }
    const editor = vscode_1.window.activeTextEditor;
    if (!editor) {
        return vscode_1.window.showInformationMessage("No active editor");
    }
    const isIntf = editor.document.uri.path.endsWith(".resi");
    const isImpl = editor.document.uri.path.endsWith(".res");
    if (!(isIntf || isImpl)) {
        await vscode_1.window.showInformationMessage("This command only can run on *.res or *.resi files.");
        return;
    }
    if (isIntf) {
        // *.res
        const newUri = editor.document.uri.with({
            path: editor.document.uri.path.slice(0, -1),
        });
        await vscode_1.window.showTextDocument(newUri, { preview: false });
        return;
    }
    if (!fs.existsSync(editor.document.uri.fsPath + "i")) {
        // if interface doesn't exist, ask the user before creating.
        const selection = await vscode_1.window.showInformationMessage("Do you want to create an interface *.resi?", ...["No", "Yes"]);
        if (selection !== "Yes")
            return;
        // create interface
        await client.sendRequest(create_interface_1.createInterfaceRequest, {
            uri: editor.document.uri.toString(),
        });
    }
    // *.resi
    const newUri = editor.document.uri.with({
        path: editor.document.uri.path + "i",
    });
    await vscode_1.window.showTextDocument(newUri, { preview: false });
    return;
};
exports.switchImplIntf = switchImplIntf;
//# sourceMappingURL=switch_impl_intf.js.map