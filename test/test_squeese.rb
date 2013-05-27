require 'test/unit'
require 'stubs'

require 'squeese'

module Squeese
  def queue
    @mock_q ||= MockSQSQueue.new
  end
end

class SqueeseTest < Test::Unit::TestCase

  def test_queue_name
    ENV['SQUEESE_QUEUE'] = 'test_queue_name'
    assert_equal 'test_queue_name', Squeese.queue_name

    Squeese.queue_name = 'override'
    assert_equal 'override', Squeese.queue_name
  end

  def test_push_pop
    worked = "capitalize"
    Squeese.job(__method__.to_s) {|item| worked.upcase!}

    assert Squeese.enqueue(__method__.to_s, {test: 1}), "Could not enqueue"
    Squeese.work_one_job
    assert_equal "CAPITALIZE", worked, "item was not worked"
  end

  def test_ignore_exception
    Squeese.job(__method__.to_s) {|item| raise "skip this because of exception"}

    assert Squeese.enqueue(__method__.to_s, {test: 1}), "Did not skip exception"
    Squeese.work_one_job
  end
end
