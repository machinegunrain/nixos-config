"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.createInterface = exports.createInterfaceRequest = void 0;
const fs = require("fs");
const node_1 = require("vscode-languageclient/node");
const vscode_1 = require("vscode");
exports.createInterfaceRequest = new node_1.RequestType("rescript-vscode.create_interface");
const createInterface = (client) => {
    if (!client) {
        return vscode_1.window.showInformationMessage("Language server not running");
    }
    const editor = vscode_1.window.activeTextEditor;
    if (!editor) {
        return vscode_1.window.showInformationMessage("No active editor");
    }
    if (fs.existsSync(editor.document.uri.fsPath + "i")) {
        return vscode_1.window.showInformationMessage("Interface file already exists");
    }
    client.sendRequest(exports.createInterfaceRequest, {
        uri: editor.document.uri.toString(),
    });
};
exports.createInterface = createInterface;
//# sourceMappingURL=create_interface.js.map