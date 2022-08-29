"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.codeAnalysisWithReanalyze = exports.switchImplIntf = exports.openCompiled = exports.createInterface = void 0;
const code_analysis_1 = require("./commands/code_analysis");
var create_interface_1 = require("./commands/create_interface");
Object.defineProperty(exports, "createInterface", { enumerable: true, get: function () { return create_interface_1.createInterface; } });
var open_compiled_1 = require("./commands/open_compiled");
Object.defineProperty(exports, "openCompiled", { enumerable: true, get: function () { return open_compiled_1.openCompiled; } });
var switch_impl_intf_1 = require("./commands/switch_impl_intf");
Object.defineProperty(exports, "switchImplIntf", { enumerable: true, get: function () { return switch_impl_intf_1.switchImplIntf; } });
const codeAnalysisWithReanalyze = (targetDir, diagnosticsCollection, diagnosticsResultCodeActions, outputChannel) => {
    (0, code_analysis_1.runCodeAnalysisWithReanalyze)(targetDir, diagnosticsCollection, diagnosticsResultCodeActions, outputChannel);
};
exports.codeAnalysisWithReanalyze = codeAnalysisWithReanalyze;
//# sourceMappingURL=commands.js.map