// bin/migrate.js
var db = require('../model');
db.sequelize.sync();