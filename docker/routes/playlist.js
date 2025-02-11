// playlist.js
const express = require('express');
const router = express.Router();
const db = require('../models');
const playlistController = require("../controller/playlist.controller.js");


router.post("/", playlistController.create);

// Retrieve all Playlists
router.get("/", playlistController.findAll);

// Retrieve a single Playlists with id
router.get("/:id", playlistController.findOne);

// Update a Playlists with id
router.put("/:id", playlistController.update);

// Delete a Playlists with id
router.delete("/:id", playlistController.delete);

module.exports = router;
