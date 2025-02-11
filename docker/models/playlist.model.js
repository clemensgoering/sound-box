module.exports = (sequelize, Sequelize) => {
    const Playlist = sequelize.define("playlist", {
      id: {
        type: Sequelize.STRING,
        allowNull: false,
        primaryKey: true
      },
      name: {
        type: Sequelize.STRING,
        allowNull: false
      }
    });
  
    return Playlist;
  };