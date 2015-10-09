require 'spec_helper'

describe Oops do

  let(:dir) {File.expand_path(File.join(File.dirname(__FILE__), 'assets'))}

  subject { described_class.new code: dir, root: dir }

  context 'without logging expectations' do
    before { allow(STDOUT).to receive(:puts).with(anything) }

    it 'runs' do
      expect{subject.run!}.not_to raise_error
    end
  end

  context 'with logging expectations' do
    let(:puts_issue) do
      JSON.dump(
        type: "issue",
        check_name: "Oopsie found",
        description: "puts found",
        categories: ["Bug Risk"],
        remediation_points: 500,
        location: {
          path: File.join(dir, 'code', 'file_one.rb'),
          positions: {
            begin: {
              line: 1,
              column: 1
            },
            end: {
              line: 1,
              column: 5
            }
          }
        }
      ) + "\0"
    end

    let(:console_issue) do
      JSON.dump(
        type: "issue",
        check_name: "Oopsie found",
        description: "console.log found",
        categories: ["Bug Risk"],
        remediation_points: 500,
        location: {
          path: File.join(dir, 'code', 'file_three.js'),
          positions: {
            begin: {
              line: 2,
              column: 12
            },
            end: {
              line: 2,
              column: 23
            }
          }
        }
      ) + "\0"
    end

    let(:rebase_issue_one) do
      JSON.dump(
        type: "issue",
        check_name: "Oopsie found",
        description: "<<<<<< found",
        categories: ["Bug Risk"],
        remediation_points: 500,
        location: {
          path: File.join(dir, 'code', 'file_two.rb'),
          positions: {
            begin: {
              line: 3,
              column: 1
            },
            end: {
              line: 3,
              column: 7
            }
          }
        }
      ) + "\0"
    end

    let(:rebase_issue_two) do
      JSON.dump(
        type: "issue",
        check_name: "Oopsie found",
        description: "====== found",
        categories: ["Bug Risk"],
        remediation_points: 500,
        location: {
          path: File.join(dir, 'code', 'file_two.rb'),
          positions: {
            begin: {
              line: 5,
              column: 1
            },
            end: {
              line: 5,
              column: 7
            }
          }
        }
      ) + "\0"
    end

    let(:rebase_issue_three) do
      JSON.dump(
        type: "issue",
        check_name: "Oopsie found",
        description: ">>>>>> found",
        categories: ["Bug Risk"],
        remediation_points: 500,
        location: {
          path: File.join(dir, 'code', 'file_two.rb'),
          positions: {
            begin: {
              line: 7,
              column: 1
            },
            end: {
              line: 7,
              column: 7
            }
          }
        }
      ) + "\0"
    end
    
    it 'logs puts issue to stdout' do
      expect(STDOUT).to receive(:puts).with(puts_issue)
      subject.check_file!(File.join(dir, 'code', 'file_one.rb'))
    end

    it 'logs rebase issue to stdout' do
      expect(STDOUT).to receive(:puts).with(rebase_issue_one).ordered
      expect(STDOUT).to receive(:puts).with(rebase_issue_two).ordered
      expect(STDOUT).to receive(:puts).with(rebase_issue_three).ordered
      subject.check_file!(File.join(dir, 'code', 'file_two.rb'))
    end

    it 'logs console issue to stdout' do
      expect(STDOUT).to receive(:puts).with(console_issue)
      subject.check_file!(File.join(dir, 'code', 'file_three.js'))
    end


  end

  it 'includes spec assets' do
    expect(subject.files_to_check).to include(
      File.join('spec', 'assets', 'code', 'file_one.rb')
    )
  end

  context 'with files' do
    let(:excluded) { File.join(dir, 'code', 'excluded', 'excluded_one.json') }

    describe '#should_check_file?' do
      it 'excludes specified assets' do
        expect(subject.should_check_file?(excluded)).to eq false
      end
    end
  end

end