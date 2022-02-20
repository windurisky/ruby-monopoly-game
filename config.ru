# config.ru
require './app'
require './app/middlewares/monopoly_backend'

use Middleware::MonopolyBackend

run App
