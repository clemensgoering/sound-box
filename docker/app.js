// sample express app created with npx express-generator --no-view src

const express = require('express');
const path = require('path');
const cookieParser = require('cookie-parser');
const logger = require('morgan');

const playlistRoute = require('./routes/playlist');
const navRoutes = require('./routes/nav');

const app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

// Routen einbinden
app.use('/', navRoutes);
app.use('/playlist', playlistRoute);

module.exports = app;

