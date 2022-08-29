"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.deactivate = exports.activate = void 0;
const path = require("path");
const vscode_1 = require("vscode");
const node_1 = require("vscode-languageclient/node");
const customCommands = require("./commands");
let client;
// let taskProvider = tasks.registerTaskProvider('Run ReScript build', {
// 	provideTasks: () => {
// 		// if (!rakePromise) {
// 		// 	rakePromise = getRakeTasks();
// 		// }
// 		// return rakePromise;
// 		// taskDefinition: TaskDefinition,
// 		// scope: WorkspaceFolder | TaskScope.Global | TaskScope.Workspace,
// 		// name: string,
// 		// source: string,
// 		// execution ?: ProcessExecution | ShellExecution | CustomExecution,
// 		// problemMatchers ?: string | string[]
// 		return [
// 			new Task(
// 				{
// 					type: 'bsb',
// 				},
// 				TaskScope.Workspace,
// 				// definition.task,
// 				'build and watch',
// 				'bsb',
// 				new ShellExecution(
// 					// `./node_modules/.bin/bsb -make-world -w`
// 					`pwd`
// 				),
// 				"Hello"
// 			)
// 		]
// 	},
// 	resolveTask(_task: Task): Task | undefined {
// 		// const task = _task.definition.task;
// 		// // A Rake task consists of a task and an optional file as specified in RakeTaskDefinition
// 		// // Make sure that this looks like a Rake task by checking that there is a task.
// 		// if (task) {
// 		// 	// resolveTask requires that the same definition object be used.
// 		// 	const definition: RakeTaskDefinition = <any>_task.definition;
// 		// 	return new Task(
// 		// 		definition,
// 		// 		definition.task,
// 		// 		'rake',
// 		// 		new vscode.ShellExecution(`rake ${definition.task}`)
// 		// 	);
// 		// }
// 		return undefined;
// 	}
// });
function activate(context) {
    let outputChannel = vscode_1.window.createOutputChannel("ReScript Language Server", "rescript");
    function createLanguageClient() {
        // The server is implemented in node
        let serverModule = context.asAbsolutePath(path.join("server", "out", "server.js"));
        // The debug options for the server
        // --inspect=6009: runs the server in Node's Inspector mode so VS Code can attach to the server for debugging
        let debugOptions = { execArgv: ["--nolazy", "--inspect=6009"] };
        // If the extension is launched in debug mode then the debug server options are used
        // Otherwise the run options are used
        let serverOptions = {
            run: { module: serverModule, transport: node_1.TransportKind.ipc },
            debug: {
                module: serverModule,
                transport: node_1.TransportKind.ipc,
                options: debugOptions,
            },
        };
        // Options to control the language client
        let clientOptions = {
            documentSelector: [{ scheme: "file", language: "rescript" }],
            // We'll send the initial configuration in here, but this might be
            // problematic because every consumer of the LS will need to mimic this.
            // We'll leave it like this for now, but might be worth revisiting later on.
            initializationOptions: {
                extensionConfiguration: vscode_1.workspace.getConfiguration("rescript.settings"),
            },
            outputChannel,
        };
        const client = new node_1.LanguageClient("ReScriptLSP", "ReScript Language Server", serverOptions, clientOptions);
        // This sets up a listener that, if we're in code analysis mode, triggers
        // code analysis as the LS server reports that ReScript compilation has
        // finished. This is needed because code analysis must wait until
        // compilation has finished, and the most reliable source for that is the LS
        // server, that already keeps track of when the compiler finishes in order to
        // other provide fresh diagnostics.
        context.subscriptions.push(client.onDidChangeState(({ newState }) => {
            if (newState === node_1.State.Running) {
                context.subscriptions.push(client.onNotification("rescript/compilationFinished", () => {
                    if (inCodeAnalysisState.active === true) {
                        customCommands.codeAnalysisWithReanalyze(inCodeAnalysisState.activatedFromDirectory, diagnosticsCollection, diagnosticsResultCodeActions, outputChannel);
                    }
                }));
            }
        }));
        return client;
    }
    // Create the language client and start the client.
    client = createLanguageClient();
    // Create a custom diagnostics collection, for cases where we want to report
    // diagnostics programatically from inside of the extension. The reason this
    // is separate from the diagnostics provided by the LS server itself is that
    // this should be possible to clear independently of the other diagnostics
    // coming from the ReScript compiler.
    let diagnosticsCollection = vscode_1.languages.createDiagnosticCollection("rescript");
    // This map will hold code actions produced by the code analysis, in a
    // format that's cheap to look up.
    let diagnosticsResultCodeActions = new Map();
    let codeAnalysisRunningStatusBarItem = vscode_1.window.createStatusBarItem(vscode_1.StatusBarAlignment.Right);
    let inCodeAnalysisState = { active: false, activatedFromDirectory: null };
    // This code actions provider yields the code actions potentially extracted
    // from the code analysis to the editor.
    vscode_1.languages.registerCodeActionsProvider("rescript", {
        async provideCodeActions(document, rangeOrSelection) {
            var _a;
            let availableActions = (_a = diagnosticsResultCodeActions.get(document.uri.fsPath)) !== null && _a !== void 0 ? _a : [];
            return availableActions
                .filter(({ range }) => range.contains(rangeOrSelection) || range.isEqual(rangeOrSelection))
                .map(({ codeAction }) => codeAction);
        },
    });
    // Register custom commands
    vscode_1.commands.registerCommand("rescript-vscode.create_interface", () => {
        customCommands.createInterface(client);
    });
    vscode_1.commands.registerCommand("rescript-vscode.open_compiled", () => {
        customCommands.openCompiled(client);
    });
    // Starts the code analysis mode.
    vscode_1.commands.registerCommand("rescript-vscode.start_code_analysis", () => {
        // Save the directory this first ran from, and re-use that when continuously
        // running the analysis. This is so that the target of the analysis does not
        // change on subsequent runs, if there are multiple ReScript projects open
        // in the editor.
        let currentDocument = vscode_1.window.activeTextEditor.document;
        inCodeAnalysisState.active = true;
        // Pointing reanalyze to the dir of the current file path is fine, because
        // reanalyze will walk upwards looking for a bsconfig.json in order to find
        // the correct project root.
        inCodeAnalysisState.activatedFromDirectory = path.dirname(currentDocument.uri.fsPath);
        codeAnalysisRunningStatusBarItem.command =
            "rescript-vscode.stop_code_analysis";
        codeAnalysisRunningStatusBarItem.show();
        codeAnalysisRunningStatusBarItem.text = "$(debug-stop) Stop Code Analyzer";
        customCommands.codeAnalysisWithReanalyze(inCodeAnalysisState.activatedFromDirectory, diagnosticsCollection, diagnosticsResultCodeActions, outputChannel);
    });
    vscode_1.commands.registerCommand("rescript-vscode.stop_code_analysis", () => {
        inCodeAnalysisState.active = false;
        inCodeAnalysisState.activatedFromDirectory = null;
        diagnosticsCollection.clear();
        diagnosticsResultCodeActions.clear();
        codeAnalysisRunningStatusBarItem.hide();
    });
    vscode_1.commands.registerCommand("rescript-vscode.switch-impl-intf", () => {
        customCommands.switchImplIntf(client);
    });
    vscode_1.commands.registerCommand("rescript-vscode.restart_language_server", () => {
        client.stop().then(() => {
            client = createLanguageClient();
            client.start();
        });
    });
    // Start the client. This will also launch the server
    client.start();
    // Restart the language client automatically when certain configuration
    // changes. These are typically settings that affect the capabilities of the
    // language client, and because of that requires a full restart.
    context.subscriptions.push(vscode_1.workspace.onDidChangeConfiguration(({ affectsConfiguration }) => {
        // Put any configuration that, when changed, requires a full restart of
        // the server here. That will typically be any configuration that affects
        // the capabilities declared by the server, since those cannot be updated
        // on the fly, and require a full restart with new capabilities set when
        // initializing.
        if (affectsConfiguration("rescript.settings.inlayHints") ||
            affectsConfiguration("rescript.settings.codeLens")) {
            vscode_1.commands.executeCommand("rescript-vscode.restart_language_server");
        }
    }));
    // Autostart code analysis if wanted
    if (vscode_1.workspace
        .getConfiguration("rescript.settings")
        .get("autoRunCodeAnalysis")) {
        vscode_1.commands.executeCommand("rescript-vscode.start_code_analysis");
    }
}
exports.activate = activate;
function deactivate() {
    if (!client) {
        return undefined;
    }
    return client.stop();
}
exports.deactivate = deactivate;
//# sourceMappingURL=extension.js.map