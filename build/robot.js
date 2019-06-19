"use strict";

const Router = require("koa-router");

const router = new Router();
router.get('/robot', async ctx => ctx.body = {
  data: "Hi! I'm robot"
});
module.exports = router;