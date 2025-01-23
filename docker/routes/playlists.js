// persons.js

var express = require('express');
var router = express.Router();
var db = require('../database.js');

router.get("/all", function(req, res) {
    db.Playlist.findAll()
        .then( playlists => {
            res.status(200).send(JSON.stringify(playlists));
        })
        .catch( err => {
            res.status(500).send(JSON.stringify(err));
        });
});

router.get("/:id", function(req, res) {
    db.Playlist.findByPk(req.params.id)
        .then( playlist => {
            res.status(200).send(JSON.stringify(playlist));
        })
        .catch( err => {
            res.status(500).send(JSON.stringify(err));
        });
});

router.put("/", function(req, res) {
    db.Playlist.create({
        name: req.body.name,
        id: req.body.id
        })
        .then( playlis => {
            res.status(200).send(JSON.stringify(playlis));
        })
        .catch( err => {
            res.status(500).send(JSON.stringify(err));
        });
});

router.delete("/:id", function(req, res) {
    db.Playlist.destroy({
        where: {
            id: req.params.id
        }
        })
        .then( () => {
            res.status(200).send();
        })
        .catch( err => {
            res.status(500).send(JSON.stringify(err));
        });
});

module.exports = router;