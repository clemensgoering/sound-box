const express = require('express');
const path = require('path');
const router = express.Router();

// Startseite
router.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/index.html'));
});

// Übersicht (RFID-Tag-Liste)
router.get('/overview', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/overview.html'));
});

// Pflegeseite (Neuen RFID hinzufügen)
router.get('/add', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/add.html'));
});

// Löschseite (RFID entfernen)
router.get('/delete', (req, res) => {
  res.sendFile(path.join(__dirname, '../public/delete.html'));
});

module.exports = router;
