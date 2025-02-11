// sample express app created with npx express-generator --no-view src

const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');

const playlistRouter = require('./routes/playlist');
const nav = require('./routes/nav');

const app = express();
const db = require("./models");

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/', nav);
app.use('/api/playlist', playlistRouter);

db.sequelize.sync({ force: true })
.then(() => {
  console.log("Drop and re-sync db.");
})
  .catch((err) => {
    console.log("Failed to sync db: " + err.message);
  });


module.exports = app;