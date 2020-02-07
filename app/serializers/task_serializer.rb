class TaskSerializer < ActiveModel::Serializer
  attributes :id, :content, :position, :done
end