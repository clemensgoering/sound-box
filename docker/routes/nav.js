const express = require('express');
const path = require('path');
const router = express.Router();

// Startseite
router.get('/', (req, res) => {
  res.render('../public/index');
});

// Übersicht (RFID-Tag-Liste)
router.get('/overview', (req, res) => {
  res.render('../public/overview');
});

// Pflegeseite (Neuen RFID hinzufügen)
router.get('/add', (req, res) => {
  res.render('../public/add');
});

// Löschseite (RFID entfernen)
router.get('/delete', (req, res) => {
  res.render('../public/delete');
});

router.get('/settings', (req, res) => {
  res.render('../public/settings');
});

module.exports = router;
