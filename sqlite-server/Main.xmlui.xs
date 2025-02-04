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
      //return JSON.stringify(data, null, 2);
      return data
    }

    function fakeCSV() {
      return [ { "firstname": "Alice", "lastname": "Johnson", "company": "TechCorp", "email": "alice.johnson@techcorp.com", "notes": "" }, { "firstname": "Bob", "lastname": "Smith", "company": "InnovateX", "email": "bob.smith@innovatex.com", "notes": "" }, { "firstname": "Charlie", "lastname": "Davis", "company": "NextGen Solutions", "email": "charlie.davis@nextgensolutions.com", "notes": "" }, { "firstname": "Dana", "lastname": "White", "company": "FutureSoft", "email": "dana.white@futuresoft.com", "notes": "" }, { "firstname": "Ethan", "lastname": "Moore", "company": "CloudNet", "email": "ethan.moore@cloudnet.com", "notes": "" }, { "firstname": "Fiona", "lastname": "Taylor", "company": "AI Systems", "email": "fiona.taylor@aisystems.com", "notes": "" }, { "firstname": "George", "lastname": "Harris", "company": "QuantumTech", "email": "george.harris@quantumtech.com", "notes": "" }, { "firstname": "Hannah", "lastname": "Clark", "company": "Skyline Ventures", "email": "hannah.clark@skylineventures.com", "notes": "" }, { "firstname": "Ian", "lastname": "Martinez", "company": "BlueOcean Inc", "email": "ian.martinez@blueoceaninc.com", "notes": "" }, { "firstname": "Julia", "lastname": "Brown", "company": "DataForge", "email": "julia.brown@dataforge.com", "notes": "" } ]
    }