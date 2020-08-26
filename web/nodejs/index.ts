import express from 'express';
import fetch from 'node-fetch';
const config = require('../config.json');

console.clear();

const app = express();
const port = config.port;

const webhook = config.webhook;
const channel = config.channel;
const token = config.token;
const debug = config.debug;

app.post("/send", (req, res) => {
	const content: any = req.query.content;
	const postWebhook: any = req.query.webhook;

	if (webhook != postWebhook) {
		const err = `error: unknown webhook '${postWebhook}'`;
		if (debug) {
			console.log(err);
		}
		return res.send(err);
	}

	const answer: any = {
		sendService: res.statusCode
	};

	fetch(webhook, {
			method: 'POST',
			body: content,
			headers: {'Content-Type': 'application/json'}
		})
		.then((discordRes: any) => discordRes.text())
		.then((body: any) => {
			answer.discordService = body;
			const jsonAnswer = JSON.stringify(answer);
			res.send(jsonAnswer);
			if (debug) {
				console.log(jsonAnswer);
			}
		});
});

app.get("/request", (req, res) => {
	fetch(`https://discordapp.com/api/channels/${channel}/messages?token=Bot ${token}`)
		.then(discordRes => discordRes.json())
		.then(json => {
			res.send(json);
			if (debug) {
				console.log(json);
			}
		});
});

app.listen(port, () => {
    console.log(`GM-Discord API server started at port ${port}`);
});