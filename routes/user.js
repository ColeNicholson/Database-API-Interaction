const UserController = new (require('../controllers/UserController'))();
const userRouter = require('koa-router')({
    prefix: '/user'
});


userRouter.get('/', UserController.users);
userRouter.get('/:user', UserController.user);
userRouter.post('/', UserController.addUser, UserController.users);
userRouter.put('/:user', UserController.updateUser, UserController.user);
userRouter.delete('/:user', UserController.deleteUser, UserController.users);

module.exports = userRouter;
