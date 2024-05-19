const { Schema, model } = require('mongoose');

const ClientSchema = new Schema({
    id: Number,
    name: String,
    address: String,
    email: String,
    phone: String
});

module.exports = model('Client', ClientSchema, 'Clients');
