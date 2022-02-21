# config.ru
require './app'
Dir[File.join(__dir__, 'app', '**', '*.rb')].each { |file| require file }

use Middleware::MonopolyBackend

run App
