class Class

  def define_readers(attr_name)
    attr_reader attr_name

    define_method "#{attr_name}_history" do
      eval("@#{attr_name}_history ||= [ nil ]")
    end
  end

  def define_writters(attr_name)
    code = <<-CODE
      def #{attr_name}=(val)
        @#{attr_name} = val
        #{attr_name}_history # Lazy eval
        @#{attr_name}_history << val
      end
    CODE
    class_eval code
  end

  def attr_accessor_with_history(*attr_names)
    attr_names.each do |attr_name|
      attr_name = attr_name.to_s

      define_readers(attr_name)
      define_writters(attr_name)
    end
  end
end

class Foo
  attr_accessor_with_history :bar, :pawa
end


f = Foo.new
f.bar = 3
f.bar = 4
f.pawa = "Hello"
puts f.pawa_history.inspect

f = Foo.new
f.bar = :hello
f.bar = "Yeah"
puts f.bar_history.inspect
