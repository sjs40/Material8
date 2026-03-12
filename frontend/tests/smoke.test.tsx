import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';

import HomePage from '../src/app/page';

describe('Home page smoke test', () => {
  it('renders title and subtitle', () => {
    render(<HomePage />);

    expect(screen.getByRole('heading', { name: 'Material8' })).toBeDefined();
    expect(
      screen.getByText('Analyst-focused dashboard for high-signal non-earnings 8-K filings.')
    ).toBeDefined();
  });
});
