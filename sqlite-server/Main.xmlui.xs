function test(foo) {
  console.log(foo.csv[0].path)
}

function test2(foo) {
  let file = foo.csv[0].path;
  let reader = new FileReader();
  reader.readAsText(file);
  reader.onload = function() {
    console.log(reader.result);
  };
}

function myOnClick(){
  console.log('myOnClick')
}

function createButtonAtTop(label) {
  const button = document.createElement('button');
  button.innerText = label;


  // Add the button at the very start (top) of <body>
  document.body.prepend(button);

  return button;
}

function parseCSV(csvString) {
  console.debug("[parseCSV] Received CSV string of length:", csvString.length);

  // 1. Split into lines (accounting for Windows \r\n)
  let lines = csvString.split(/\r?\n/);
  console.debug("[parseCSV] Number of lines after split:", lines.length);

  // 2. Trim each line and remove empty lines
  lines = lines
    .map((line, idx) => {
      const trimmed = line.trim();
      console.debug(`[parseCSV] Line #${idx}: "${line}" -> trimmed -> "${trimmed}"`);
      return trimmed;
    })
    .filter((line, idx) => {
      const keep = line.length > 0;
      console.debug(`[parseCSV] Filter line #${idx}: "${line}" -> keep? ${keep}`);
      return keep;
    });

  console.debug("[parseCSV] Number of lines after trimming/filtering:", lines.length);

  // 3. Check for minimal CSV lines
  if (lines.length < 2) {
    console.warn("[parseCSV] Less than 2 lines – no headers or data. Returning [].");
    return [];
  }

  // 4. Extract headers from the first line
  const headerLine = lines[0];
  console.debug(`[parseCSV] Header line: "${headerLine}"`);
  const headers = headerLine.split(',').map((h, idx) => {
    const trimmed = h.trim();
    console.debug(`[parseCSV] Header #${idx}: "${h}" -> "${trimmed}"`);
    return trimmed;
  });
  console.debug("[parseCSV] Final headers array:", headers);

  // 5. Convert each subsequent line into an object keyed by headers
  const data = lines.slice(1).map((line, lineIdx) => {
    console.debug(`[parseCSV] Processing data line #${lineIdx + 1}: "${line}"`);
    const values = line.split(',');
    console.debug(`[parseCSV] Raw split values:`, values);

    const rowObject = {};
    headers.forEach((header, i) => {
      const rawValue = values[i] || "";
      const trimmedValue = rawValue.trim();
      rowObject[header] = trimmedValue;
      console.debug(
        `[parseCSV] -> rowObject["${header}"] = "${trimmedValue}" (from raw value "${rawValue}")`
      );
    });

    console.debug(`[parseCSV] Constructed row object #${lineIdx + 1}:`, rowObject);
    return rowObject;
  });

  console.debug("[parseCSV] Final parsed data:", data);
  return data;
}
