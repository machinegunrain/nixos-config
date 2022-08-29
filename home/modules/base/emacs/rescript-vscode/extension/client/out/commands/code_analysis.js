"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.runCodeAnalysisWithReanalyze = void 0;
const cp = require("child_process");
const fs = require("fs");
const path = require("path");
const vscode_1 = require("vscode");
let resultsToDiagnostics = (results, diagnosticsResultCodeActions) => {
    let diagnosticsMap = new Map();
    results.forEach((item) => {
        {
            let startPos, endPos;
            let [startLine, startCharacter, endLine, endCharacter] = item.range;
            // Detect if this diagnostic is for the entire file. If so, reanalyze will
            // say that the issue is on line -1. This code below ensures
            // that the full file is highlighted, if that's the case.
            if (startLine < 0 || endLine < 0) {
                startPos = new vscode_1.Position(0, 0);
                endPos = new vscode_1.Position(99999, 0);
            }
            else {
                startPos = new vscode_1.Position(startLine, startCharacter);
                endPos = new vscode_1.Position(endLine, endCharacter);
            }
            let issueLocationRange = new vscode_1.Range(startPos, endPos);
            let diagnosticText = item.message.trim();
            let diagnostic = new vscode_1.Diagnostic(issueLocationRange, diagnosticText, vscode_1.DiagnosticSeverity.Warning);
            // Don't show reports about optional arguments.
            if (item.name.toLowerCase().includes("unused argument")) {
                return;
            }
            if (diagnosticsMap.has(item.file)) {
                diagnosticsMap.get(item.file).push(diagnostic);
            }
            else {
                diagnosticsMap.set(item.file, [diagnostic]);
            }
            // If reanalyze suggests a fix, we'll set that up as a refactor code
            // action in VSCode. This way, it'll be easy to suppress the issue
            // reported if wanted. We also save the range of the issue, so we can
            // leverage that to make looking up the code actions for each cursor
            // position very cheap.
            if (item.annotate != null) {
                {
                    let { line, character, text, action } = item.annotate;
                    let codeAction = new vscode_1.CodeAction(action);
                    codeAction.kind = vscode_1.CodeActionKind.RefactorRewrite;
                    let codeActionEdit = new vscode_1.WorkspaceEdit();
                    // In the future, it would be cool to have an additional code action
                    // here for automatically removing whatever the thing that's dead is.
                    codeActionEdit.replace(vscode_1.Uri.parse(item.file), 
                    // Make sure the full line is replaced
                    new vscode_1.Range(new vscode_1.Position(line, character), new vscode_1.Position(line, character)), 
                    // reanalyze seems to add two extra spaces at the start of the line
                    // content to replace.
                    text);
                    codeAction.edit = codeActionEdit;
                    if (diagnosticsResultCodeActions.has(item.file)) {
                        diagnosticsResultCodeActions
                            .get(item.file)
                            .push({ range: issueLocationRange, codeAction });
                    }
                    else {
                        diagnosticsResultCodeActions.set(item.file, [
                            { range: issueLocationRange, codeAction },
                        ]);
                    }
                }
            }
        }
    });
    return {
        diagnosticsMap,
    };
};
let analysisDevPath = path.join(path.dirname(__dirname), "..", "..", "analysis", "rescript-editor-analysis.exe");
let analysisProdPath = path.join(path.dirname(__dirname), "..", "..", "server", "analysis_binaries", process.platform, "rescript-editor-analysis.exe");
let getAnalysisBinaryPath = () => {
    if (fs.existsSync(analysisDevPath)) {
        return analysisDevPath;
    }
    else if (fs.existsSync(analysisProdPath)) {
        return analysisProdPath;
    }
    else {
        return null;
    }
};
const runCodeAnalysisWithReanalyze = (targetDir, diagnosticsCollection, diagnosticsResultCodeActions, outputChannel) => {
    var _a;
    let currentDocument = vscode_1.window.activeTextEditor.document;
    let cwd = targetDir !== null && targetDir !== void 0 ? targetDir : path.dirname(currentDocument.uri.fsPath);
    let binaryPath = getAnalysisBinaryPath();
    if (binaryPath === null) {
        vscode_1.window.showErrorMessage("Binary executable not found.", analysisProdPath);
        return;
    }
    let opts = ["reanalyze", "-json"];
    let p = cp.spawn(binaryPath, opts, {
        cwd,
    });
    if (p.stdout == null) {
        vscode_1.window.showErrorMessage("Something went wrong.");
        return;
    }
    let data = "";
    p.stdout.on("data", (d) => {
        data += d;
    });
    (_a = p.stderr) === null || _a === void 0 ? void 0 : _a.on("data", (e) => {
        // Sometimes the compiler artifacts has been corrupted in some way, and
        // reanalyze will spit out a "End_of_file" exception. The solution is to
        // clean and rebuild the ReScript project, which we can tell the user about
        // here.
        if (e.includes("End_of_file")) {
            vscode_1.window.showErrorMessage(`Something went wrong trying to run reanalyze. Please try cleaning and rebuilding your ReScript project.`);
        }
        else {
            vscode_1.window.showErrorMessage(`Something went wrong trying to run reanalyze: '${e}'`);
        }
    });
    p.on("close", () => {
        diagnosticsResultCodeActions.clear();
        let json = null;
        try {
            json = JSON.parse(data);
        }
        catch (e) {
            vscode_1.window
                .showErrorMessage(`Something went wrong when running the code analyzer.`, "See details in error log")
                .then((_choice) => {
                outputChannel.show();
            });
            outputChannel.appendLine("\n\n>>>>");
            outputChannel.appendLine("Parsing JSON from reanalyze failed. The raw, invalid JSON can be reproduced by following the instructions below. Please run that command and report the issue + failing JSON on the extension bug tracker: https://github.com/rescript-lang/rescript-vscode/issues");
            outputChannel.appendLine(`> To reproduce, run "${binaryPath} ${opts.join(" ")}" in directory: "${cwd}"`);
            outputChannel.appendLine("\n");
        }
        if (json == null) {
            // If reanalyze failed for some reason we'll clear the diagnostics.
            diagnosticsCollection.clear();
            return;
        }
        let { diagnosticsMap } = resultsToDiagnostics(json, diagnosticsResultCodeActions);
        // This smoothens the experience of the diagnostics updating a bit by
        // clearing only the visible diagnostics that has been fixed after the
        // updated diagnostics has been applied.
        diagnosticsCollection.forEach((uri, _) => {
            if (!diagnosticsMap.has(uri.fsPath)) {
                diagnosticsCollection.delete(uri);
            }
        });
        diagnosticsMap.forEach((diagnostics, filePath) => {
            diagnosticsCollection.set(vscode_1.Uri.parse(filePath), diagnostics);
        });
    });
};
exports.runCodeAnalysisWithReanalyze = runCodeAnalysisWithReanalyze;
//# sourceMappingURL=code_analysis.js.map