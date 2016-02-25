class PublishStatus
  ENUM = [  {id: :draft, label: "Draft"},
            {id: :published, label: "Published"}]
  include EnumBase
end
