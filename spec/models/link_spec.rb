require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe 'validate url' do
    let(:question) { create :question }
    let!(:valid_link) { build(:link, url: 'http://google.com/', linkable: question) }
    let!(:invalid_link) { build(:link, url: 'googlecom', linkable: question) }

    it { expect(valid_link).to be_valid }
    it { expect(invalid_link).to be_invalid }

    it 'have message' do
      invalid_link.validate
      expect(invalid_link.errors[:url]).to include('is not a valid URL')
    end
  end

  describe 'Link#gist?' do
    let(:question) { create :question }
    let!(:google_link) { build(:link, url: 'http://google.com/', linkable: question) }
    let!(:gist_link) { build(:link, url: 'https://gist.github.com/sergeynakul/ba9556a2dba56dbfdf1027fc2f590c38', linkable: question) }

    it { expect(google_link).to_not be_gist }
    it { expect(gist_link).to be_gist }
  end

  describe 'Link#gist' do
    let!(:gist_link) { build(:link, url: 'https://gist.github.com/sergeynakul/ba9556a2dba56dbfdf1027fc2f590c38') }

    it { expect(gist_link.gist).to be_a_kind_of Array }
    it { expect(gist_link.gist.first).to include(name: 'SQL запросы', content: "sergey@comp:~$ sqlite3 test_guru\nsqlite> create table categories(id integer primary key autoincrement, title varchar(30));\nsqlite> create table tests(id integer primary key autoincrement, title varchar(30), level integer, categories_id integer not null, foreign key (categories_id) references categories(id));\nsqlite> create table questions (\n   ...> id integer primary key autoincrement,\n   ...> body text,\n   ...> tests_id integer not null,\n   ...> foreign key (tests_id) references tests(id)\n   ...> );\nsqlite> insert into categories(title) values\n   ...> ('HTML'),\n   ...> ('CSS'),\n   ...> ('RUBY');\nsqlite> insert into tests(title, level, categories_id) values\n   ...> ('Basic html', 0, 1),\n   ...> ('Basic css', 0, 2),\n   ...> ('Basic ruby', 0, 3),\n   ...> ('Advanced ruby', 3, 3),\n   ...> ('Average ruby', 2, 3);\nsqlite> insert into questions(body, tests_id) values\n   ...> ('That is html', 1),\n   ...> ('That is css?', 2),\n   ...> ('That is ruby?', 3),\n   ...> ('That is exeption?', 5),\n   ...> ('That is metaprogramming?', 4);\nsqlite> select * from tests where level = 2 or level = 3;\n4|Advanced ruby|3|3\n5|Average ruby|2|3\nsqlite> select * from questions where tests_id = 1;\n1|That is html|1\nsqlite> update tests\n   ...> set title = 'Intermediate ruby', level = 2\n   ...> where id = 4;\nsqlite> delete from questions where tests_id = 4;\nsqlite> select tests.title, categories.title\n   ...> from tests\n   ...> join categories\n   ...> on tests.categories_id = categories.id;\nBasic html|HTML\nBasic css|CSS\nBasic ruby|RUBY\nIntermediate ruby|RUBY\nAverage ruby|RUBY\nsqlite> select questions.body, tests.title\n   ...> from questions\n   ...> join tests\n   ...> on questions.tests_id = tests.id;\nThat is html|Basic html\nThat is css?|Basic css\nThat is ruby?|Basic ruby\nThat is exeption?|Average ruby   ") }
  end
end
