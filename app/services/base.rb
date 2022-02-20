module Service
  class Base
    def self.run!(*args, &block)
      new(*args, &block).run!
    end
  end
end
