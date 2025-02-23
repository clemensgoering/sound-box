const dbConfig = require("../config/db.config.js");

const Sequelize = require("sequelize");
const sequelize = new Sequelize(dbConfig.DB, dbConfig.USER, dbConfig.PASSWORD, {
  host: dbConfig.HOST,
  dialect: dbConfig.dialect,
  dialectOptions: {},  
  define: {
    //prevent sequelize from pluralizing table names
    freezeTableName: true
  },
  pool: {
    max: dbConfig.pool.max,
    min: dbConfig.pool.min,
    acquire: dbConfig.pool.acquire,
    idle: dbConfig.pool.idle
  }
});

const Rfid = require("./rfid.model.js")(sequelize, Sequelize);

module.exports = {
    sequelize: sequelize,
    Sequelize: Sequelize,
    Rfid: Rfid
};
