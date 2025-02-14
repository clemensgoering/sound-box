module.exports = (sequelize, Sequelize) => {

    const Rfid = sequelize.define("Rfid", {
      id: {
        type: Sequelize.STRING,
        allowNull: false,
        primaryKey: true
      },
      name: {
        type: Sequelize.STRING,
        allowNull: false
      },
      type: {
        type: Sequelize.STRING,
        allowNull: false,
        isIn: [['spotify', 'youtube', 'local']], 
      },
      source: {
        type: Sequelize.STRING,
        allowNull: false
      }
    });
  
    return Rfid;
  };