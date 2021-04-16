import { markdown, fail } from 'danger';
import { readFileSync } from 'fs';

//  Flutter Format Report
//  flutter format ./ > flutter_format_report.txt
function parseFormattedFilePath(line: string): string | null {
    const result = line.match(/^Formatted (.+).dart$/);
    if (result == null) return null; else return `${result[1]}.dart`;
}

const flutterFormatReport = readFileSync('flutter_format_report.txt', 'utf-8');
const formattedFilePaths = flutterFormatReport.split('\n').map(parseFormattedFilePath).filter(path => path != null);

if (formattedFilePaths.length != 0) {
    markdown('## Flutter Format Report\n');
    markdown(`${formattedFilePaths.length} issue(s) found.\n`);   
    for (var path of formattedFilePaths) markdown(`* ${path}`);
 
    fail(`Flutter Format Report: ${formattedFilePaths.length} issue(s) found.`);
}


//  Flutter Analyze Report
interface Issue { level: string; message: string; file: string; rule: string; }

function parseIssueLine(line: string): Issue | null {
    const result = line.match(/(\s*)(info|warning|error) • (.+) • (.+) • (.+)/);
    if (result == null) return null;
    else return { level: result[2], message: result[3], file: result[4], rule: result[5] };
}

const flutterAnalyzeReport = readFileSync('flutter_analyze_report.txt', 'utf-8');
const issues = flutterAnalyzeReport.split('\n').map(parseIssueLine).filter(issue => issue != null);

if (issues.length != 0) {
    var table = '| Level | Message | File | Rule |\n|:---|:---|:---|:---|\n';
    for (var issue of issues) {
        const ruleLink = `[${issue.rule}](https://dart-lang.github.io/linter/lints/${issue.rule}.html)`;
        table += `| ${issue.level} | ${issue.message} | ${issue.file} | ${ruleLink} |\n`;
    }

    markdown('## Flutter Analyze Report\n');
    markdown(`${issues.length} issue(s) found.\n`);
    markdown(table);

    fail(`Flutter Analyze Report: ${issues.length} issue(s) found.`);
}
