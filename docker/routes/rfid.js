// playlist.js
const express = require('express');
const router = express.Router();
const rfidController = require("../controller/rfid.controller.js");

router.post("/", rfidController.create);

// Retrieve all Playlists
router.get("/", rfidController.findAll);

// Retrieve a single Playlists with id
router.get("/:rfid", rfidController.findOne);

// Update a Playlists with id
router.put("/", rfidController.update);

// Delete a Playlists with id
router.delete("/", rfidController.delete);

module.exports = router;
