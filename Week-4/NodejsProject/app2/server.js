const express = require('express');
const app = express();
const PORT = 5002;

app.get('/app2', (req, res) => {
    res.send('Hello from App 2 terraform & codedeploy demo!!');
});

app.listen(PORT, () => {
    console.log(`App 2 running on port ${PORT}`);
});