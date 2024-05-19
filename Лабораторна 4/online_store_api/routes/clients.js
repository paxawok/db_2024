const express = require('express');
const router = express.Router();
const client = require('../database');

// отримання доступу до всіх даних документу з клієнтами
router.get('/', async (req, res) => {
    try {
        const db = client.db('online_store');
        const collection = db.collection('Clients');
        const documents = await collection.find().sort({ _id: 1 }).toArray();
        res.json(documents);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching clients from the database' });
    }
});

// отримання даних про клієнта по id
router.get('/:id', async (req, res) => {
    try {
        const db = client.db('online_store');
        const collection = db.collection('Clients');
        const id = parseInt(req.params.id);

        if (isNaN(id)) {
            return res.status(400).json({ message: 'Invalid ID format' });
        }

        const clientData = await collection.findOne({ id: id });

        if (clientData) {
            res.json(clientData);
        } else {
            res.status(404).json({ message: 'Client not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error fetching client from the database' });
    }
});

// створення нових даних
router.post('/', async (req, res) => {
    try {
        const db = client.db('online_store');
        const collection = db.collection('Clients');
        const newClient = req.body;

        await collection.insertOne(newClient);
        res.send('Client added successfully');
    } catch (error) {
        res.status(500).json({ message: 'Error adding client to the database' });
    }
});

// оновлення даних
router.put('/:id', async (req, res) => {
    try {
        const db = client.db('online_store');
        const collection = db.collection('Clients');
        const id = parseInt(req.params.id);
        const { name, address, email, phone } = req.body;

        const result = await collection.updateOne(
            { id: id },
            { $set: { name: name, address: address, email: email, phone: phone } }
        );

        res.send('Client updated successfully');
    } catch (error) {
        res.status(500).json({ message: 'Error updating client in the database' });
    }
});

// видалення
router.delete('/:id', async (req, res) => {
    try {
        const db = client.db('online_store');
        const collection = db.collection('Clients');
        const id = parseInt(req.params.id);

        await collection.deleteOne({ id: id });
        res.send('Client deleted successfully');
    } catch (error) {
        res.status(500).json({ message: 'Error deleting client from the database' });
    }
});

module.exports = router;