function parseCSV(csvString) {
      // If fileResult isn’t loaded yet, bail out
      if (!csvString) {
        return "No CSV content yet";
      }

      // Simple CSV -> JSON: first line is headers
      const lines = csvString
        .split(/\r?\n/) // handle Win/Mac/Linux line endings
        .map(l => l.trim())
        .filter(l => l);

      if (lines.length < 2) {
        return "No valid lines";
      }

      const headers = lines[0].split(",").map(h => h.trim());
      const data = lines.slice(1).map(line => {
        const values = line.split(",");
        const row = {};
        headers.forEach((header, i) => {
          row[header] = (values[i] || "").trim();
        });
        return row;
      });

      // Return the parsed JSON (or a string representation)
      return JSON.stringify(data, null, 2);
    }