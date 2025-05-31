const express = require('express');
const bodyParser = require('body-parser');
const puppeteer = require('puppeteer');

const app = express();
app.use(bodyParser.json());

app.post('/generate-pdf', async (req, res) => {
    const { htmlContent } = req.body;

    try {
        const browser = await puppeteer.launch({
            args: ['--no-sandbox', '--disable-setuid-sandbox'],
        });
        const page = await browser.newPage();
        await page.setContent(htmlContent);

        const pdf = await page.pdf({
            format: 'A4',
            printBackground: true,
        });

        await browser.close();
        res.contentType('application/pdf');
        res.send(pdf);
    } catch (error) {
        console.error('Error generating PDF:', error);  // Log the actual error
        res.status(500).send({ error: 'Error generating PDF', details: error.message });
    }
});

app.listen(3000, () => {
    console.log('PDF Service running on port 3000');
});
