function countItems(items) { 
  console.log(items)
  return items.length
}


function showItems(items) { 
  items = items.slice(0,2)
  console.log(jsonToMarkdownTable(items))
  return jsonToMarkdownTable(items)
}

function jsonToMarkdownTable(data) {
    const header = '| Title | Time | By | URL |\n| ----- | ---- | -- | --- |';
    
    const rows = data.map(item => {
        const time = new Date(item.time).toLocaleString();
        const title = item.title.replace(/\|/g, '\\|');
        return `| ${title} | ${time} | ${item.by} | ${item.url} |`;
    }).join('\n');

    return `${header}\n${rows}`;
}