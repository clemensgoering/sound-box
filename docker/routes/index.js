const express = require('express');
const router = express.Router();

/* GET home page. */
router.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'index.html'));
});

router.get('/overview', async (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'overview.html'));
});

router.get('/delete', async (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'delete.html'));
});

router.get('/add', async (req, res) => {
  res.sendFile(path.join(__dirname, 'views', 'add.html'));
});

router.get('/api/rfid', async (req, res) => {
  try {
    const result = await pool.query('SELECT * FROM playlist');
    res.json(result.rows);
  } catch (err) {
    console.error('Fehler beim Abrufen der RFID-Daten:', err);
    res.status(500).json({ error: 'Fehler beim Abrufen der RFID-Daten' });
  }
});

module.exports = router;
