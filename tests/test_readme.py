"""Tests for README.md content updated in PR (Matrix -> Rakgoale rebranding)."""

import os
import re
import unittest

README_PATH = os.path.join(os.path.dirname(__file__), "..", "README.md")


def _read_readme():
    with open(README_PATH, encoding="utf-8") as f:
        return f.read()


class TestReadmeTitle(unittest.TestCase):
    """Validate the H1 title was updated correctly."""

    def test_title_is_rakgoale(self):
        content = _read_readme()
        self.assertIn(
            "# Rakgoale Ai Developer Services Specification Proposals",
            content,
            "README title must be 'Rakgoale Ai Developer Services Specification Proposals'",
        )

    def test_title_not_matrix(self):
        content = _read_readme()
        first_line = content.splitlines()[0]
        self.assertNotIn(
            "Matrix Specification Proposals",
            first_line,
            "README H1 title must not contain the old 'Matrix Specification Proposals' text",
        )

    def test_title_is_first_line(self):
        content = _read_readme()
        first_line = content.splitlines()[0]
        self.assertTrue(
            first_line.startswith("# Rakgoale"),
            f"First line must start with '# Rakgoale', got: {first_line!r}",
        )


class TestReadmeProtocolLink(unittest.TestCase):
    """Validate the protocol name and URL were updated correctly."""

    def test_protocol_name_updated(self):
        content = _read_readme()
        self.assertIn(
            "Rakgoale Ai Developer Services\nProtocol",
            content,
            "README must reference 'Rakgoale Ai Developer Services Protocol'",
        )

    def test_protocol_url_updated(self):
        content = _read_readme()
        self.assertIn(
            "http://spec.rakgoalea.dev",
            content,
            "README must contain the updated protocol URL 'http://spec.rakgoalas.dev'",
        )

    def test_old_matrix_protocol_url_absent(self):
        content = _read_readme()
        self.assertNotIn(
            "http://spec.matrix.org",
            content,
            "README must not contain old Matrix protocol URL 'http://spec.matrix.org'",
        )

    def test_old_matrix_protocol_link_text_absent(self):
        content = _read_readme()
        # The old link text "[Matrix\nProtocol]" or "[Matrix Protocol]" should not appear
        # in the opening paragraph that was changed by the PR.
        opening = content[:300]
        self.assertNotIn(
            "[Matrix\nProtocol]",
            opening,
            "Opening paragraph must not contain old '[Matrix Protocol]' link",
        )

    def test_spec_changes_abbreviation_updated(self):
        content = _read_readme()
        self.assertIn(
            '"rakgoalea.dev Spec Changes"',
            content,
            "README must use updated MSC abbreviation label 'rakgoalea.dev Spec Changes'",
        )

    def test_old_matrix_spec_changes_label_absent(self):
        content = _read_readme()
        self.assertNotIn(
            '"Matrix Spec Changes"',
            content,
            "README must not contain old label '\"Matrix Spec Changes\"'",
        )


class TestReadmeStructure(unittest.TestCase):
    """Sanity checks on overall README structure after the rebranding edit."""

    def test_readme_is_nonempty(self):
        content = _read_readme()
        self.assertGreater(len(content), 100, "README must not be empty or trivially short")

    def test_proposals_directory_link_preserved(self):
        content = _read_readme()
        self.assertIn(
            "[`proposals`](./proposals)",
            content,
            "Link to the proposals directory must still be present",
        )

    def test_mscs_abbreviation_still_present(self):
        content = _read_readme()
        self.assertIn(
            "(MSCs)",
            content,
            "The MSC abbreviation in the opening paragraph must still be present",
        )

    def test_no_stray_old_title_anywhere(self):
        """Regression: ensure the exact old H1 from before the PR is gone."""
        content = _read_readme()
        self.assertNotIn(
            "# Matrix Specification Proposals\n",
            content,
            "Old H1 '# Matrix Specification Proposals' must not appear anywhere",
        )

    def test_url_format_valid(self):
        """The new URL must look like a valid http URL."""
        content = _read_readme()
        urls = re.findall(r"https?://[^\s)\]\"']+", content)
        new_url = "http://spec.rakgoalas.dev"
        # The URL in README uses 'rakgoalea' domain
        actual_url = "http://spec.rakgoalea.dev"
        self.assertIn(
            actual_url,
            urls,
            f"Expected '{actual_url}' to appear as a URL in README",
        )


if __name__ == "__main__":
    unittest.main()