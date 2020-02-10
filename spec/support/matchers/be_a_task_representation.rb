RSpec::Matchers.define :be_a_task_representation do |task|
  match do |json|
    attributes = %i[id content done]
    response_attributes = task.attributes.slice(*attributes)

    expect(json).to be
    expect(json).to include(response_attributes)
  end
end
