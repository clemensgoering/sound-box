module.exports = {
    HOST: process.env.DB_HOST || 'localhost',
    USER: process.env.DB_USER || 'postgres',
    PASSWORD: process.env.DB_PASSWORD || 'pg1234',
    DB: "soundbox",
    PORT: process.env.DB_PORT || 5432,
    SCHEMA: process.env.DB_SCHEMA || 'postgres',
    dialect: "postgres",
    dialectOptions: {
        ssl: process.env.DB_SSL == "true"
    },
    pool: {
      max: 5,
      min: 0,
      acquire: 30000,
      idle: 10000
    }
  };