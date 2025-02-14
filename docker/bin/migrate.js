// bin/migrate.js
var db = require('../models');
db.sequelize.sync();