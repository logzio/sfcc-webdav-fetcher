const fs = require('fs');

const path = 'grokPatternList.json';
const fluentdFile = 'fluentd/etc/grokParse.conf';
try {
    if (fs.existsSync(path)) {
        const data = fs.readFileSync(path);
        const parsedData = JSON.parse(data);
        const regex = /\\/g;
        const stringBackslash = '\\';

        let dataConf = [];
        for (const key in parsedData) {
            if (parsedData[key].length > 0) {
                const dataConfStart = [
                    `<filter sfcc.${key}>`,
                    '@type parser',
                    `inject_key_prefix ${key}.`,
                    'reserve_time true',
                    'reserve_data true',
                    '<parse>',
                    '@type grok',
                ];
                dataConf = [...dataConf, ...dataConfStart];
                parsedData[key].forEach((pattern) => {
                    dataConf.push('<grok>');
                    dataConf.push(pattern.replace(regex, stringBackslash));
                    dataConf.push('</grok>');
                });
                dataConf.push('</parse>');
                dataConf.push('</filter>');
            }
        }
        fs.writeFileSync(fluentdFile, dataConf.join('\n'));
    } else {
        console.log(
            'INFO: grok patterns for sfcc logs is not defined, or named in different.',
        );
    }
} catch (e) {
    console.log('Error:', e.stack);
}
