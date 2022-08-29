"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.openCompiled = void 0;
const fs = require("fs");
const vscode_1 = require("vscode");
const node_1 = require("vscode-languageclient/node");
let openCompiledFileRequest = new node_1.RequestType("rescript-vscode.open_compiled");
const openCompiled = (client) => {
    if (!client) {
        return vscode_1.window.showInformationMessage("Language server not running");
    }
    const editor = vscode_1.window.activeTextEditor;
    if (!editor) {
        return vscode_1.window.showInformationMessage("No active editor");
    }
    if (!fs.existsSync(editor.document.uri.fsPath)) {
        return vscode_1.window.showInformationMessage("Compiled file does not exist");
    }
    client
        .sendRequest(openCompiledFileRequest, {
        uri: editor.document.uri.toString(),
    })
        .then((response) => {
        const document = vscode_1.Uri.file(response.uri);
        return vscode_1.window.showTextDocument(document, {
            viewColumn: vscode_1.ViewColumn.Beside,
        });
    });
};
exports.openCompiled = openCompiled;
//# sourceMappingURL=open_compiled.js.map