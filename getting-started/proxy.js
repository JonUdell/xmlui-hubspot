const express = require('express');
const axios = require('axios');
const cors = require('cors');
const app = express();

// Enable CORS for all routes
app.use(cors());
app.use(express.json());

app.post('/api/turbot-proxy', async (req, res) => {
  try {
    const body = Object.values(req.query).join('');
    console.log('Received request:', body); // Debug logging
    
    const response = await axios.post(
      'https://pipes.turbot.com/api/latest/org/turbot-ops/workspace/stats/query',
      body,
      {
        headers: {
          'Authorization': 'Bearer spt_cbu2opfm19mroepv6gk0_36q9v3yapo8ud34oyj8p5ruln'
        }
      }
    );
    res.json(response.data);
  } catch (error) {
    console.error('Error:', error.response?.data || error.message); // Debug logging
    res.status(500).json({ 
      error: error.message,
      details: error.response?.data
    });
  }
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Proxy server running on http://localhost:${PORT}`);
});

