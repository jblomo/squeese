require 'aws'

class MockSQSQueue
  def initialize
    @q = []
  end

  def delete
    @q = []
    true
  end

  def send_message(body)
    @q.push(Aws::Sqs::Message.new(self, "MockMessageId=", nil, body))
    {MessageId: "MockMessageId=",
     MD5OfMessageBody: "deadbeef"}
  end

  def pop
    @q.pop
  end

end
