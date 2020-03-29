const dotenv = require('dotenv');
const express = require('express');
const bodyParser = require('body-parser');
const { Pool, Client } = require('pg');

dotenv.config();
const app = express();

const pool = new Pool({
  connectionString: process.env.CONNECTION
});

app.use(bodyParser.json());

app.get('/all-potholes', (req, res, next) => {
  pool.query('SELECT * FROM pothole', (qerr, qres) => {
    if (qerr) {
      res.status(500).send(qerr);
    } else {
      res.send(qres.rows);
    }
  });
});

app.get('/all-details', (req, res, next) => {
  pool.query('SELECT * FROM pothole_details', (qerr, qres) => {
    if (qerr) {
      res.status(500).send(qerr);
    } else {
      res.send(qres.rows);
    }
  });
});

app.post('/add-pothole', async (req, res, next) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');
    const queryText = 'INSERT INTO pothole (latitude, longitude) VALUES ($1, $2) RETURNING id';
    const resq = await client.query(queryText, [req.body.latitude, req.body.longitude]);
    let insertDetailsText;
    let insertDetailsValues;
    if (req.body.picture && req.body.rating && req.body.description) {
      insertDetailsText = 'INSERT INTO pothole_details(id, picture, rating, description) VALUES ($1, $2, $3, $4)';
      insertDetailsValues = [resq.rows[0].id, req.body.picture, req.body.rating, req.body.description];
    } else if (!req.body.picture && req.body.rating && req.body.description) {
      insertDetailsText = 'INSERT INTO pothole_details(id, rating, description) VALUES ($1, $2, $3)';
      insertDetailsValues = [resq.rows[0].id, req.body.rating, req.body.description];
    } else if (req.body.picture && !req.body.rating && req.body.description) {
      insertDetailsText = 'INSERT INTO pothole_details(id, picture, description) VALUES ($1, $2, $3)';
      insertDetailsValues = [resq.rows[0].id, req.body.picture, req.body.description];
    } else if (req.body.picture && req.body.rating && !req.body.description) {
      insertDetailsText = 'INSERT INTO pothole_details(id, picture, rating) VALUES ($1, $2, $3)';
      insertDetailsValues = [resq.rows[0].id, req.body.picture, req.body.rating];
    } else if (!req.body.picture && !req.body.rating && req.body.description) {
      insertDetailsText = 'INSERT INTO pothole_details(id, description) VALUES ($1, $2)';
      insertDetailsValues = [resq.rows[0].id, req.body.description];
    } else if (!req.body.picture && req.body.rating && !req.body.description) {
      insertDetailsText = 'INSERT INTO pothole_details(id, rating) VALUES ($1, $2)';
      insertDetailsValues = [resq.rows[0].id, req.body.rating];
    } else if (req.body.picture && !req.body.rating && !req.body.description) {
      insertDetailsText = 'INSERT INTO pothole_details(id, picture) VALUES ($1, $2)';
      insertDetailsValues = [resq.rows[0].id, req.body.picture];
    } else if (!req.body.picture && !req.body.rating && !req.body.description) {
      insertDetailsText = 'INSERT INTO pothole_details(id) VALUES ($1)';
      insertDetailsValues = [resq.rows[0].id];
    }
    await client.query(insertDetailsText, insertDetailsValues);
    await client.query('COMMIT');
    client.release()
    res.sendStatus(200);
  } catch (e) {
    await client.query('ROLLBACK');
    client.release()
    res.sendStatus(500);
  }
});

app.listen(80);