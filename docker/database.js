// database.js

const Sequelize = require('sequelize');
const sequelize = new Sequelize(process.env.DB_SCHEMA || 'postgres',
                                process.env.DB_USER || 'postgres',
                                process.env.DB_PASSWORD || 'pg1234',
                                {
                                    host: process.env.DB_HOST || 'postgres',
                                    port: process.env.DB_PORT || 5432,
                                    dialect: 'postgres',
                                    dialectOptions: {
                                        ssl: process.env.DB_SSL == "true"
                                    }
                                });
const Playlist = sequelize.define('Playlist', {
    name: {
        type: Sequelize.STRING,
        allowNull: false
    },
});
module.exports = {
    sequelize: sequelize,
    Playlist: Playlist
};