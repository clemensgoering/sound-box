const db = require("../models");
const Rfid = db.Rfid;
const Op = db.Sequelize.Op;

// Create and Save a new Rfid
exports.create = (req, res) => {
    // Validate request
    if (!req.body.id) {
      res.status(400).send({
        message: "RFID Identifier missing"
      });
      return;
    }

    if (!req.body.type && !req.body.source) {
      res.status(400).send({
        message: "Type and source cant be empty"
      });
      return;
    }
  
    // Create a Rfid
    const rfid = {
      id: req.body.id,
      name: req.body.name,
      type: req.body.type,
      source: req.body.source,
    };
  
    // Save Rfid in the database
    Rfid.create(rfid)
      .then(data => {
        res.send(data);
      })
      .catch(err => {
        res.status(500).send({
          message:
            err.message || "Some error occurred while creating the Rfid."
        });
      });
  };

// Retrieve all Rfid from the database.
exports.findAll = (req, res) => {
  Rfid.findAll()
      .then(data => {
        res.send(data);
      })
      .catch(err => {
        res.status(500).send({
          message:
            err.message || "Some error occurred while retrieving Rfid."
        });
      });
  };
// Find a single Rfid with an id
exports.findOne = (req, res) => {
    const id = req.params.rfid;
  
    Rfid.findByPk(id)
      .then(data => {
        if (data) {
          res.send(data);
        } else {
          res.status(404).send({
            message: `Cannot find Rfid with id=${id}.`
          });
        }
      })
      .catch(err => {
        res.status(500).send({
          message: "Error retrieving Rfid with id=" + id
        });
      });
  };

// Update a Rfid by the id in the request
exports.update = (req, res) => {
    // Create a Rfid
    const rfid = {
      id: req.body.id,
      name: req.body.name,
      type: req.body.type,
      source: req.body.source,
    };

    Rfid.update(req.body, {
      where: { id: rfid.id }
    })
      .then(num => {
        if (num == 1) {
          res.send({
            message: "Rfid was updated successfully."
          });
        } else {
          res.send({
            message: `Cannot update Rfid with id=${id}. Maybe Tutorial was not found or req.body is empty!`
          });
        }
      })
      .catch(err => {
        res.status(500).send({
          message: "Error updating Rfid with id=" + id
        });
      });
  };

// Delete a Rfid with the specified id in the request
exports.delete = (req, res) => {
    const ids = req.body.ids;
  
    Rfid.destroy({
      where: { id: ids }
    })
      .then(num => {
        if (num == 1) {
          res.send({
            message: "Rfid was deleted successfully!"
          });
        } else {
          res.send({
            message: `Cannot delete Rfid with id=${id}. Maybe Rfid was not found!`
          });
        }
      })
      .catch(err => {
        res.status(500).send({
          message: "Could not delete Rfid with id=" + ids
        });
      });
  };
