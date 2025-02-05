const express = require('express');
const app = express();
const PORT = 5001;

app.get('/app1', (req, res) => {
    res.send('Hello from App 1 terraform & codedeploy!!');
});

app.listen(PORT, () => {
    console.log(`App 1 running on port ${PORT}`);
});