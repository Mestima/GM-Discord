"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const node_fetch_1 = __importDefault(require("node-fetch"));
const config = require('../config.json');
console.clear();
const app = express_1.default();
const port = config.port;
const webhook = config.webhook;
const channel = config.channel;
const token = config.token;
const security = config.security;
const debug = config.debug;
app.post("/send", (req, res) => {
    const content = req.query.content;
    const postWebhook = req.query.webhook;
    if (webhook != postWebhook) {
        const err = `error: unknown webhook '${postWebhook}'`;
        if (debug) {
            console.log(err);
        }
        return res.send(err);
    }
    const answer = {
        sendService: res.statusCode
    };
    node_fetch_1.default(webhook, {
        method: 'POST',
        body: content,
        headers: { 'Content-Type': 'application/json' }
    })
        .then((discordRes) => discordRes.text())
        .then((body) => {
        answer.discordService = body;
        const jsonAnswer = JSON.stringify(answer);
        res.send(jsonAnswer);
        if (debug) {
            console.log(jsonAnswer);
        }
    });
});
app.get("/request", (req, res) => {
    if (security) {
        const postToken = req.query.token;
        const postChannel = req.query.channel;
        if (channel != postChannel || token != postToken) {
            const err = `error: unknown token or channel`;
            if (debug) {
                console.log(err);
            }
            return res.send(err);
        }
    }
    node_fetch_1.default(`https://discordapp.com/api/channels/${channel}/messages?token=Bot ${token}`)
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
