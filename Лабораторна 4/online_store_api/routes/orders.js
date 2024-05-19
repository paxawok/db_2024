const express = require('express');
const router = express.Router();
const client = require('../database');

// Отримання всіх замовлень
router.get('/', async (req, res) => {
  try {
    const db = client.db('online_store');
    const collection = db.collection('Orders');
    const documents = await collection.find().sort({ _id: 1 }).toArray();
    res.json(documents);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching orders from the database' });
  }
});

// Отримання замовлення за ID
router.get('/:id', async (req, res) => {
  try {
    const db = client.db('online_store');
    const collection = db.collection('Orders');
    const id = parseInt(req.params.id);

    if (isNaN(id)) {
      return res.status(400).json({ message: 'Invalid ID format' });
    }

    const orderData = await collection.findOne({ id: id });

    if (orderData) {
      res.json(orderData);
    } else {
      res.status(404).json({ message: 'Order not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error fetching order from the database' });
  }
});

// Створення нового замовлення
router.post('/', async (req, res) => {
  try {
    const db = client.db('online_store');
    const collection = db.collection('Orders');
    const newOrder = req.body;

    newOrder.id = generateOrderId(); // Генерація нового ID для замовлення
    await collection.insertOne(newOrder);
    res.send('Order added successfully');
  } catch (error) {
    res.status(500).json({ message: 'Error adding order to the database' });
  }
});

// Оновлення замовлення за ID
router.put('/:id', async (req, res) => {
  try {
    const db = client.db('online_store');
    const collection = db.collection('Orders');
    const id = parseInt(req.params.id);
    const { client_id, status, order_date } = req.body;

    const result = await collection.updateOne(
      { id: id },
      { $set: { client_id: client_id, status: status, order_date: order_date } }
    );

    if (result.modifiedCount > 0) {
      res.send('Order updated successfully');
    } else {
      res.status(404).json({ message: 'Order not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error updating order in the database' });
  }
});

// Видалення замовлення за ID
router.delete('/:id', async (req, res) => {
  try {
    const db = client.db('online_store');
    const collection = db.collection('Orders');
    const id = parseInt(req.params.id);

    const result = await collection.deleteOne({ id: id });

    if (result.deletedCount > 0) {
      res.send('Order deleted successfully');
    } else {
      res.status(404).json({ message: 'Order not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error deleting order from the database' });
  }
});

// Генерація нового ID для замовлення
function generateOrderId() {
  const prefix = 66600000; // Префікс 456 і наступні 5 нулів
  const randomId = Math.floor(Math.random() * 90000) + 10000; // генерація випадкового 5-значного числа
  return prefix + randomId;
}

module.exports = router;
